package br.edu.ufr.campusconnect.campusconnectapi.controller;

import br.edu.ufr.campusconnect.campusconnectapi.domain.profile.dto.DadosPerfilUsuario;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.ProdutoRepository;
import br.edu.ufr.campusconnect.campusconnectapi.domain.profile.dto.DadosProdutoUsuario;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/profile")
public class ProfileController {

    @Autowired
    private ProdutoRepository produtoRepository;

    @GetMapping("/me")
    @Transactional(readOnly = true) // Boa prática para endpoints de leitura
    public ResponseEntity<DadosPerfilUsuario> meuPerfil(Authentication authentication) {
        var usuario = (Usuario) authentication.getPrincipal();

        var produtosDoUsuario = produtoRepository.findByVendedorId(usuario.getId())
                .stream()
                .map(DadosProdutoUsuario::new)
                .collect(Collectors.toList());

        var dadosPerfil = new DadosPerfilUsuario(usuario, produtosDoUsuario);

        return ResponseEntity.ok(dadosPerfil);
    }
}
