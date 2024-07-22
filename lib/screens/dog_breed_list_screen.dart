import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/dog_breed.dart';
import '../services/dog_breed_service.dart';
import '../services/google_auth_service.dart'; // Importa o GoogleAuthService
import 'dog_breed_detail_screen.dart';

class DogBreedListScreen extends StatefulWidget {
  @override
  _DogBreedListScreenState createState() => _DogBreedListScreenState();
}

class _DogBreedListScreenState extends State<DogBreedListScreen> {
  final DogBreedService dogBreedService = DogBreedService();
  final ScrollController _scrollController = ScrollController();

  List<DogBreed> _dogBreeds = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _initialItemsPerPage = 7;
  final int _subsequentItemsPerPage = 2;
  bool _isLoggedIn = false; // Variável de estado para controle de login/logout
  GoogleSignInAccount? _currentUser; // Armazena o usuário logado

  @override
  void initState() {
    super.initState();
    _loadInitialDogBreeds();
    _scrollController.addListener(_onScroll);
    _currentUser = GoogleAuthService.currentUser;
    _isLoggedIn = _currentUser != null;
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading &&
        _hasMore) {
      _fetchMoreDogBreeds();
    }
  }

  void _loadInitialDogBreeds() {
    _dogBreeds = [];
    _currentPage = 0;
    _hasMore = true;
    _fetchMoreDogBreeds();
  }

  Future<void> _fetchMoreDogBreeds() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
        Duration(seconds: 5)); // Adiciona um atraso de 5 segundos

    final isInitialLoad = _currentPage == 0;
    final newDogBreeds = await dogBreedService.fetchDogBreeds(
      startIndex: _currentPage *
          (isInitialLoad ? _initialItemsPerPage : _subsequentItemsPerPage),
      limit: isInitialLoad ? _initialItemsPerPage : _subsequentItemsPerPage,
    );

    setState(() {
      _dogBreeds.addAll(newDogBreeds);
      _currentPage++;
      _isLoading = false;
      if (newDogBreeds.length <
          (isInitialLoad ? _initialItemsPerPage : _subsequentItemsPerPage)) {
        _hasMore = false;
      }
    });
  }

  Future<void> _toggleLoginState() async {
    setState(() {
      _isLoading = true;
    });

    if (_isLoggedIn) {
      await GoogleAuthService.signOutGoogle();
    } else {
      _currentUser = await GoogleAuthService.signInWithGoogle();
    }

    setState(() {
      _isLoggedIn = GoogleAuthService.currentUser != null;
      _isLoading = false;
    });

    // Exibir mensagem de estado de login
    final loginStateMessage = _isLoggedIn
        ? 'Usuário logado com sucesso'
        : 'Usuário deslogado com sucesso';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loginStateMessage)),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog Breeds'),
        actions: [
          IconButton(
            icon: Icon(_isLoggedIn ? Icons.logout : Icons.login),
            onPressed: _toggleLoginState,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Número de colunas
                    crossAxisSpacing:
                        4.0, // Espaçamento horizontal entre as colunas
                    mainAxisSpacing:
                        4.0, // Espaçamento vertical entre as linhas
                  ),
                  itemCount: _dogBreeds.length,
                  itemBuilder: (context, index) {
                    final dogBreed = _dogBreeds[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DogBreedDetailScreen(
                              title: dogBreed.title,
                              description: dogBreed.description,
                              imagePath: dogBreed.path,
                              additionalImages: dogBreed.additionalImages,
                            ),
                          ),
                        ).then((_) {
                          // Resetar a lista de dog breeds ao voltar da tela de detalhes
                          _loadInitialDogBreeds();
                        });
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.asset(
                                dogBreed.path,
                                fit: BoxFit
                                    .cover, // Ajusta a imagem para cobrir o espaço disponível
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(dogBreed.title),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_isLoading)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
