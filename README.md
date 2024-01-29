# cinemapedia

1. Copiar el .env.template y renombrarlo a env
2. combiar las varibales de entorno (The MovieDB)
3. Cambios en la identidad , hay que ejecutar el comando
'''
flutter pub run build_runner build
'''

# Prod
Cambiar el nombre de la aplicación
'''
flutter pub run change_app_package_name:main com.new.package.name
'''

Para cambiar el icono de la aplicación
'''
flutter pub run flutter_launcher_icons
'''

Para cambiar el splash screen
'''
dart run flutter_native_splash:create
'''

Android AAB
'''
flutter build appbundle
'''