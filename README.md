Онлайн-библиотека на Flutter
============================

Данный проект разработан в качестве учебной работы по дисциплине **«Разработка мобильных приложений»** студентом **Саидмасумовым Шерзодом** (4 курс, группа 025-21, заочный факультет «Компьютерный инжиниринг») Ташкентского Университета Информационных Технологий.

### Описание проекта

Проект представляет собой **онлайн-библиотеку**, реализованную на фреймворке [Flutter](https://flutter.dev/) с использованием:

*   **Firebase** (Authentication и Firestore) для аутентификации и хранения данных о книгах.
    
*   **Open Library API** для поиска книг и получения метаданных.
    
*   **Google Books API** для предпросмотра книг в онлайн-режиме.
    

### Основные функции приложения

1.  **Регистрация и авторизация** через Firebase Authentication (email/пароль).
    
2.  **Поиск книг** по названию и автору (с помощью Open Library).
    
3.  **Отображение детальной информации** о книге (обложка, описание, год публикации, количество страниц).
    
4.  **Чтение книги онлайн** (если доступен предпросмотр в Google Books).
    
5.  **Сохранение книг** в «Моей библиотеке», хранящейся в Firebase Firestore.
    

### Структура

*   **lib/models** – модели данных (например, Book).
    
*   **lib/screens** – экраны (авторизация, список книг, детали, личная библиотека).
    
*   **lib/services** – сервисы для работы с Firebase, Open Library и Google Books.
    
*   **lib/widgets** – переиспользуемые виджеты, такие как карточки книг.
    
*   **web** – файлы для веб-сборки (при необходимости).
    
*   **pubspec.yaml** – спецификация пакетов и зависимостей.
    

### Цель работы

Создать учебное кроссплатформенное приложение, демонстрирующее:

*   Архитектуру клиентской части (Flutter).
    
*   Использование облачных сервисов (Firebase).
    
*   Интеграцию с внешними API (Open Library, Google Books).
    

### Скриншоты и видео-демонстрация

*   **Скриншоты** (см. папку screenshots/ или раздел «Приложения» в документации).
    
*   **Видео**: [Ссылка на YouTube](https://www.youtube.com/shorts/-5FkejbTvSM).
    

### Как запустить проект

1.  Установить Flutter SDK (минимальная версия, например, >=3.0.0).
    
2.  bashCopy codegit clone https://github.com/username/flutter-online-library.git
    
3.  bashCopy codecd flutter-online-libraryflutter pub getflutter run
    
4.  При необходимости настроить файл firebase\_options.dart или использовать flutterfire configure для своей учётной записи Firebase.
    

### Автор

**Саидмасумов Шерзод**, студент 4 курса (группа 025-21) заочного факультета «Компьютерный инжиниринг» Ташкентского Университета Информационных Технологий.

> _Данный проект выполнен в рамках учебной программы и предназначен для демонстрации навыков разработки кроссплатформенных мобильных приложений с применением облачных сервисов._