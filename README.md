# my_experimentations

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


graph TB
    A[App Layer] --> B[MultipeerService]
    B --> C[MCSession]
    
    C --> D[Encryption Layer]
    D -->|AES-128| E[Encrypted Data]
    
    E --> F[Transport Layer]
    F -->|Wi-Fi Direct| G[Physical Layer]
    F -->|Bluetooth| G
    
    G --> H[Remote Device]
    
    style D fill:#FFD700
    style E fill:#50C878
