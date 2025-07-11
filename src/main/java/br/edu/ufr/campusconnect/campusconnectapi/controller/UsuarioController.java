package br.edu.ufr.campusconnect.campusconnectapi.controller;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.UsuarioRepository;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.dto.DadosCadastroUsuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/auth")
public class UsuarioController {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @PostMapping("/register")
    public ResponseEntity<String> registrar(@RequestBody DadosCadastroUsuario dados) {
        // Lógica de validação (ex: verificar se o e-mail já existe) será adicionada depois

        // Mapeia o DTO para a Entidade
        var usuario = new Usuario();
        usuario.setNomeCompleto(dados.nomeCompleto());
        usuario.setEmail(dados.email());
        // IMPORTANTE: Aqui vamos salvar a senha em texto plano por enquanto.
        // A lógica de criptografia (hash) será adicionada com o Spring Security.
        usuario.setSenhaHash(dados.senha());

        usuarioRepository.save(usuario);

        return ResponseEntity.status(201).body("Usuário registrado com sucesso. Verifique seu e-mail para ativar a conta.");
    }
}
