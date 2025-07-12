package br.edu.ufr.campusconnect.campusconnectapi.controller;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.UsuarioService;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.dto.DadosCadastroUsuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService; // <-- Mudamos para injetar o Serviço

    @PostMapping("/register")
    @Transactional // Boa prática para operações de escrita
    public ResponseEntity<String> registrar(@RequestBody DadosCadastroUsuario dados) {
        usuarioService.registrar(dados);
        return ResponseEntity.status(201).body("Usuário registrado com sucesso.");
    }
}
