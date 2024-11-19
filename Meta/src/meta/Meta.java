/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */
package meta;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

public class Meta {
    public static void main(String[] args) {
        String basePath = System.getProperty("user.dir");
        String ruta1 = basePath + "/src/meta/Lexer.flex";
        String ruta2 = basePath + "/src/meta/LexerCup.flex";
        String[] rutaS = {"-parser", "Sintax", basePath + "/src/meta/Sintax.cup"};
        generar(ruta1, ruta2, rutaS);
    }

    public static void generar(String ruta1, String ruta2, String[] rutaS){
        try {
            // Generar Lexer
            jflex.Main.generate(new String[]{ruta1});
            jflex.Main.generate(new String[]{ruta2});

            // Generar el parser
            java_cup.Main.main(rutaS);
            
            // Mover sym.java y Sintax.java a la ubicación correcta
            moverArchivo("sym.java", "src/meta/sym.java");
            moverArchivo("Sintax.java", "src/meta/Sintax.java");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public static void moverArchivo(String archivoOrigen, String archivoDestino) {
        Path origen = Paths.get(System.getProperty("user.dir") + "/" + archivoOrigen);
        Path destino = Paths.get(System.getProperty("user.dir") + "/" + archivoDestino);

        try {
            if (Files.exists(destino)) {
                Files.delete(destino);
            }
            Files.move(origen, destino);
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}


