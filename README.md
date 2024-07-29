#Dog Breeds

Dog Breeds é um aplicativo Flutter que exibe uma lista de raças de cães, permite ao usuário visualizar detalhes sobre cada raça, curtir e comentar, além de oferecer autenticação via Google.

Sumário
- Visão Geral
- Funcionalidades
- Instalação
- Uso
- Estrutura do Projeto

#Visão Geral

Este aplicativo foi desenvolvido para demonstrar o uso de Flutter para criar uma interface de usuário responsiva e interativa, integrando funcionalidades como autenticação com Google, persistência de dados locais e exibição de listas com paginação.

Funcionalidades:
- Autenticação via Google
- Exibição de uma lista de raças de cães
- Paginação infinita para carregar mais raças conforme o usuário rola a tela
- Visualização de detalhes de cada raça, incluindo uma galeria de imagens e descrição
- Capacidade de curtir e comentar nas imagens

Instalação
Pré-requisitos:
- Flutter (versão 2.0 ou superior)
- Dart

#Passos para Instalação

1. Clone o repositório:
- git clone https://github.com/seu-usuario/dog-breeds.git
- cd dog-breeds
  
2. Instale as dependências:
- flutter pub get
  
3. Configure a conexão com o google
  - falta documentar...
    
4. Execute o app
- flutter run
  
#Uso

Após iniciar o aplicativo, você verá a tela de lista de raças de cães. Você pode rolar a tela para carregar mais raças, tocar em uma raça para ver os detalhes, curtir e comentar nas imagens. Use o ícone de login no topo para autenticar com sua conta do Google.

#Estrutura do Projeto
lib/
- main.dart: Ponto de entrada do aplicativo.
- screens/: Contém as telas principais do aplicativo.
- dog_breed_list_screen.dart: Tela que exibe a lista de raças.
- dog_breed_detail_screen.dart: Tela de detalhes da raça.
models/: Contém as classes de modelo.
- dog_breed.dart: Modelo para uma raça de cachorro.
  
services/: Contém os serviços de lógica de negócios.
- dog_breed_service.dart: Serviço para buscar dados de raças.
- google_auth_service.dart: Serviço para autenticação com Google.
  
widgets/: Contém os widgets reutilizáveis.
- comment_section.dart: Widget para seção de comentários.
- like_button.dart: Widget para botão de curtir.
