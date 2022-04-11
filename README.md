# Eventos
App iOS que exibe uma lista de eventos e seus detalhes.

![Simulator Screen Recording - iPhone 11 - 2022-04-10 at 23 00 38](https://user-images.githubusercontent.com/62032419/162652761-f4fce76d-2d81-4464-b495-d0102367b0ef.gif)

## Recursos e técnicas empregadas:
  - MVVM (Model, View, View Model) com RxSwift para fazer binding entre View e View Model.
  - Generics, URLSession e rotas customizadas para criação da camada de networking.
  - Injeção de dependência.
  - Princípios SOLID.
  - View Code para criação das interfaces.
  - SPM para gerenciamento de dependências externas.
  - MapKit para exibição de mapa.
  - Testes unitários com XCTest.
  - Human Interface Guidelines da Apple.
  - Tratativa de erros com exibição de mensagens amigáveis ao usuário.

## Features:
  - Listagem de eventos cadastrados na API: título, número de inscritos, valor, data.
  - Exibição de detalhes do evento: título, imagem, valor, data, texto descritivo.
  - Check-In em evento: envio de check-in API; validação dos campos de nome e e-mail; mensagem de confirmação.
  - Mapa do evento: exibição de mapa com a localização do evento.
  - Compartilhamento de evento

## Biliotecas externas:
  - RxSwift (https://github.com/ReactiveX/RxSwift)
  - KingFisher (https://github.com/onevcat/Kingfisher)

## Estrutura do projeto:

<img width="404" alt="image" src="https://user-images.githubusercontent.com/62032419/162655006-b21f1a40-8033-4513-a7ee-7d3e25ec7a6b.png">

## Todo:
  - Aumentar a cobertura de testes.
  - Remover variáveis mágicas.
  - Aprimorar interface.
