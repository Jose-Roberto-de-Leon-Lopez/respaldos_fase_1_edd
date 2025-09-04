#!/bin/bash

# Compila el programa principal
# -Fuinterfaces indica dónde buscar las unidades adicionales
fpc -Fuinterfaces -Fudata -Fustructures -Futools main.pas;

# Ejecuta el programa compilado
./main;

# Elimina archivos intermedios generados por la compilación
rm *.o;           
rm -r main;       

# Limpieza de la carpeta interfaces
rm interfaces/*.o;    
rm interfaces/*.ppu; 

# Eliminar los archivos generados en la carpeta structures
rm structures/*.o;    
rm structures/*.ppu;  

# Eliminar los archivos generados en la carpeta tools
rm tools/*.o;
rm tools/*.ppu;

# Eliminar los archivos generados en la carpeta data
rm data/*.o;
rm data/*.ppu; 