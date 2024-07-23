import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/dog_breed.dart';
import '../services/dog_breed_service.dart';
import '../services/google_auth_service.dart';
import 'dog_breed_detail_screen.dart';

class DogBreedListScreen extends StatefulWidget {
  @override
  _DogBreedListScreenState createState() => _DogBreedListScreenState();
}

class _DogBreedListScreenState extends State<DogBreedListScreen> {
  final DogBreedService _dogBreedService = DogBreedService();
  final ScrollController _scrollController = ScrollController();

  List<DogBreed> _dogBreeds = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _itemsPerPage = 8;
  bool _isLoggedIn = false;
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() {
    _loadInitialDogBreeds();
    _scrollController.addListener(_onScroll);
    _currentUser = GoogleAuthService.currentUser;
    _isLoggedIn = _currentUser != null;
  }

  void _onScroll() {
    if (_isEndOfList() && !_isLoading && _hasMore) {
      _fetchMoreDogBreeds();
    }
  }

  bool _isEndOfList() {
    return _scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent;
  }

  void _loadInitialDogBreeds() {
    setState(() {
      _dogBreeds = [];
      _currentPage = 0;
      _hasMore = true;
    });
    _fetchMoreDogBreeds();
  }

  Future<void> _fetchMoreDogBreeds() async {
    if (_isLoading) return;
    _setLoadingState(true);

    await Future.delayed(Duration(seconds: 5));

    final newDogBreeds = await _dogBreedService.fetchDogBreeds(
      startIndex: _currentPage * _itemsPerPage,
      limit: _itemsPerPage,
    );
    _updateDogBreedsState(newDogBreeds);
  }

  void _updateDogBreedsState(List<DogBreed> newDogBreeds) {
    setState(() {
      _dogBreeds.addAll(newDogBreeds);
      _currentPage++;
      _isLoading = false;
      if (newDogBreeds.length < _itemsPerPage) {
        _hasMore = false;
      }
    });
  }

  void _setLoadingState(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Future<void> _toggleLoginState() async {
    _setLoadingState(true);

    if (_isLoggedIn) {
      await GoogleAuthService.signOutGoogle();
    } else {
      _currentUser = await GoogleAuthService.signInWithGoogle();
    }

    _updateLoginState();
    _showLoginStateMessage();
  }

  void _updateLoginState() {
    setState(() {
      _isLoggedIn = GoogleAuthService.currentUser != null;
      _isLoading = false;
    });
  }

  void _showLoginStateMessage() {
    final loginStateMessage = _isLoggedIn
        ? 'Usuário logado com sucesso'
        : 'Usuário deslogado com sucesso';
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(loginStateMessage)));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildDogBreedGrid(),
          if (_isLoading) _buildLoadingIndicator(),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Dog Breeds'),
      actions: [
        IconButton(
          icon: Icon(_isLoggedIn ? Icons.logout : Icons.login),
          onPressed: _toggleLoginState,
        ),
      ],
    );
  }

  Widget _buildDogBreedGrid() {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
            ),
            itemCount: _dogBreeds.length,
            itemBuilder: (context, index) {
              return _buildDogBreedCard(_dogBreeds[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDogBreedCard(DogBreed dogBreed) {
    return GestureDetector(
      onTap: () => _navigateToDogBreedDetail(dogBreed),
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                dogBreed.path,
                fit: BoxFit.cover,
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
  }

  void _navigateToDogBreedDetail(DogBreed dogBreed) {
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
      _loadInitialDogBreeds();
    });
  }

  Widget _buildLoadingIndicator() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
