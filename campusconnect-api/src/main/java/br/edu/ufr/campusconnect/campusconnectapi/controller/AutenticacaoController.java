package br.edu.ufr.campusconnect.campusconnectapi.controller;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.dto.DadosAutenticacao;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.dto.DadosTokenJWT;
import br.edu.ufr.campusconnect.campusconnectapi.infra.security.TokenService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/auth")
public class AutenticacaoController {

    @Autowired
    private AuthenticationManager manager;

    @Autowired
    private TokenService tokenService;

    @PostMapping("/login")
    public ResponseEntity efetuarLogin(@RequestBody DadosAutenticacao dados) {
        var authenticationToken = new UsernamePasswordAuthenticationToken(dados.email(), dados.senha());
        var authentication = manager.authenticate(authenticationToken);

        var tokenJWT = tokenService.gerarToken((Usuario) authentication.getPrincipal());

        return ResponseEntity.ok(new DadosTokenJWT(tokenJWT));
    }

    @GetMapping("/hello")
    public String hello() {
        return "Olá, Mundo! Você está autenticado.";
    }
}

