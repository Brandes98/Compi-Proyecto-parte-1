package meta;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.StringReader;
import java.nio.file.Files;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java_cup.runtime.Symbol;
import javax.swing.JFileChooser;
import static meta.Tokens.CARACTER_NO_DEFINIDO;
import static meta.Tokens.CHAR_NO_CERRADO;
import static meta.Tokens.COMENTARIO_NO_FINALIZADO;
import static meta.Tokens.ERROR;
import static meta.Tokens.IDENTIFICADOR_INVALIDO;
import static meta.Tokens.Identificador;
import static meta.Tokens.Literal;
import static meta.Tokens.NUMERO_INCOMPLETO;
import static meta.Tokens.Preprocesador;
import static meta.Tokens.STRING_NO_CERRADO;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */

/**
 *
 * @author brand
 */
public class frmPrincipal extends javax.swing.JFrame {

    /**
     * Creates new form frmPrincipal
     */
    public frmPrincipal() {  
        initComponents();
        setLocationRelativeTo(null);
    }
    
    private void analizarLexico(){  
        String expr = (String) txtResultado.getText();
        Lexer lexer = new Lexer(new StringReader(expr));
        StringBuilder resultado = new StringBuilder();

        while (true) {
            try {
                Tokens token = lexer.yylex();
                if (token == null) {
                    break;
                }
                if(token == Tokens.COMENTARIO_NO_FINALIZADO){
                    resultado.append(String.format("Comentario no Finalizado %d\n", lexer.lineNumber));
                    break;
                }
                
                switch (token) {                  
                    case Break:
                    case Case:
                    case Char:
                    case Const:
                    case Continue:
                    case Default:
                    case Do:
                    case Else:
                    case For:
                    case If:
                    case Int:
                    case Long:
                    case Return:
                    case Short:
                    case Switch:
                    case Void:
                    case While:  
                    case Read:
                    case Write:
                    case Incremento:
                    case Decremento:
                    case Igualdad:
                    case MayorIgual:
                    case Mayor:
                    case MenorIgual:
                    case Menor:
                    case Desigualdad:
                    case Or:
                    case And:
                    case Not:
                    case Asignacion:
                    case Suma:
                    case Resta:
                    case Multiplicacion:
                    case Division:
                    case Modulo:
                    case ParentesisA:
                    case ParentesisC:
                    case LlaveA:
                    case LlaveC:
                    case AsignacionSuma:
                    case AsignacionResta:
                    case AsignacionMultiplicacion:
                    case AsignacionDivision:
                    case Coma:
                    case PuntoComa:
                    case Hexadecimal:
                    case Octal:
                    case Decimal:
                    case Flotante:
                    case Identificador:
                    case Preprocesador:
                    case Literal:
                    case Reservada:
                    case Operador:
                        break;
                        
                    case NUMERO_INCOMPLETO:
                        resultado.append(String.format("Número incompleto en línea %d\n", lexer.lineNumber));
                        break;
                    case IDENTIFICADOR_INVALIDO:
                        resultado.append(String.format("Identificador inválido que comienza con un número en línea %d\n", lexer.lineNumber));
                        break;
                    case ERROR:
                        resultado.append(String.format("Error en línea %d\n", lexer.lineNumber));
                        break;
                    case COMENTARIO_NO_FINALIZADO:
                        resultado.append(String.format("Error: Comentario de bloque no finalizado en línea %d\n", lexer.lineNumber));
                        break;
                    case STRING_NO_CERRADO:
                        resultado.append(String.format("Error: String no cerrada en línea %d\n", lexer.lineNumber));
                        break;
                    case STRING_MULTILINEA_CERRADO:
                        resultado.append(String.format("Error: String multilínea en línea %d\n", lexer.lineNumber));
                        break;
                    case CHAR_NO_CERRADO:
                        resultado.append(String.format("Error: Carácter no cerrado en línea %d\n", lexer.lineNumber));
                        break;
                    case CARACTER_NO_DEFINIDO:
                        resultado.append(String.format("Error: Carácter no definido encontrado en línea %d: %s\n", lexer.lineNumber, lexer.lexeme));
                        break;
                        
                    default:
                        System.out.println("Token devuelto: " + token);
                        resultado.append(String.format("Token Desconocido en línea %d\n", lexer.lineNumber));
                        break;
                }
            } catch (IOException ex) {
                Logger.getLogger(frmPrincipal.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        
        if (resultado.length() == 0) {
            txtResultadoLe.setText("Análisis léxico exitoso.");
        } else {
            txtResultadoLe.setText(resultado.toString());
        }
        
        
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jScrollPane1 = new javax.swing.JScrollPane();
        txtResultado = new javax.swing.JTextArea();
        btnSeleccionar = new javax.swing.JButton();
        btnSintactico = new javax.swing.JButton();
        jScrollPane2 = new javax.swing.JScrollPane();
        txtResultadoSin = new javax.swing.JTextArea();
        jScrollPane3 = new javax.swing.JScrollPane();
        txtResultadoLe = new javax.swing.JTextArea();
        btnLexico = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setResizable(false);

        txtResultado.setColumns(20);
        txtResultado.setRows(5);
        jScrollPane1.setViewportView(txtResultado);

        btnSeleccionar.setText("SELECCIONAR");
        btnSeleccionar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnSeleccionarActionPerformed(evt);
            }
        });

        btnSintactico.setText("ANALIZAR SINTÁXIS");
        btnSintactico.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnSintacticoActionPerformed(evt);
            }
        });

        txtResultadoSin.setColumns(20);
        txtResultadoSin.setRows(5);
        jScrollPane2.setViewportView(txtResultadoSin);

        txtResultadoLe.setColumns(20);
        txtResultadoLe.setRows(5);
        jScrollPane3.setViewportView(txtResultadoLe);

        btnLexico.setText("ANALIZAR LÉXICO");
        btnLexico.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnLexicoActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 390, Short.MAX_VALUE)
                    .addComponent(btnSeleccionar, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(btnSintactico, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 390, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 390, Short.MAX_VALUE)
                    .addComponent(btnLexico, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(btnSintactico, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(btnSeleccionar, javax.swing.GroupLayout.DEFAULT_SIZE, 80, Short.MAX_VALUE)
                    .addComponent(btnLexico, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 402, Short.MAX_VALUE)
                    .addComponent(jScrollPane2)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.Alignment.TRAILING))
                .addContainerGap())
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnSeleccionarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnSeleccionarActionPerformed
        // TODO add your handling code here:
        analizarArchivo();
    }//GEN-LAST:event_btnSeleccionarActionPerformed

    private void btnSintacticoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnSintacticoActionPerformed
        // TODO add your handling code here:
        
        String ST = txtResultado.getText();
        Sintax s = new Sintax(new meta.LexerCup(new StringReader(ST)));

        try {
            s.parse();
            List<String> errores = s.getErrores();

            if (errores.isEmpty()) {
                txtResultadoSin.setText("Análisis sintáctico exitoso");
            } else {
                StringBuilder errorMsg = new StringBuilder("Se encontraron los siguientes errores:\n\n");
                for (String error : errores) {
                    errorMsg.append(error).append("\n"); // Separa cada error con una nueva línea
                }
                txtResultadoSin.setText(errorMsg.toString());
            }
        } catch (Exception ex) {
            Symbol sym = s.getS();
            String errorMsg = String.format("[ERROR FATAL] En línea %d, columna %d: %s",
                    sym.right, sym.left, sym.value);
            txtResultadoSin.setText(errorMsg);
        }
    }//GEN-LAST:event_btnSintacticoActionPerformed

    private void btnLexicoActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnLexicoActionPerformed
        analizarLexico();
    }//GEN-LAST:event_btnLexicoActionPerformed

    public void analizarArchivo() {
        JFileChooser chooser = new JFileChooser();
        int returnVal = chooser.showOpenDialog(null);

        if (returnVal == JFileChooser.APPROVE_OPTION) {
            File selectedFile = new File(chooser.getSelectedFile().getAbsolutePath());

            try {
                String ST = new String(Files.readAllBytes(selectedFile.toPath()));
                txtResultado.setText(ST);
                
            } catch (FileNotFoundException ex) {
                System.out.println("Error: Archivo no encontrado.");
            } catch (IOException ex) {
                System.out.println("Error: Problema de E/S.");
            }
        } else {
            System.out.println("No se seleccionó ningún archivo.");
    }
}
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(frmPrincipal.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(frmPrincipal.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(frmPrincipal.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(frmPrincipal.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new frmPrincipal().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnLexico;
    private javax.swing.JButton btnSeleccionar;
    private javax.swing.JButton btnSintactico;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JTextArea txtResultado;
    private javax.swing.JTextArea txtResultadoLe;
    private javax.swing.JTextArea txtResultadoSin;
    // End of variables declaration//GEN-END:variables
}
