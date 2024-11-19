/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package meta;

/**
 *
 * @author brand
 */
class Symbol {
    String nombre;
    String tipo;
    String ambito;

    public Symbol(String nombre, String tipo, String ambito) {
        this.nombre = nombre;
        this.tipo = tipo;
        this.ambito = ambito;
    }

    @Override
    public String toString() {
        return "Nombre: " + nombre + ", Tipo: " + tipo + ", Ámbito: " + ambito;
    }
}

