#flutter clean
#flutter pub get
fvm flutter build apk --release
firebase appdistribution:distribute build/app/outputs/flutter-apk/app-release.apk --app 1:353946571533:android:0c31a6ed7b3c5b7d72d644 --groups tester



