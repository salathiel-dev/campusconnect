package br.edu.ufr.campusconnect.campusconnectapi.controller;

import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.ChatService;
import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosIniciarConversa;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosListagemMensagem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import java.util.UUID;

@RestController
@RequestMapping("/chats")
public class ChatController {

    @Autowired
    private ChatService chatService;

    @PostMapping("/iniciar")
    @Transactional
    public ResponseEntity iniciarConversa(@RequestBody DadosIniciarConversa dados, Authentication authentication) {
        var comprador = (Usuario) authentication.getPrincipal();
        var dadosConversa = chatService.iniciarOuRetornarConversa(dados, comprador);
        return ResponseEntity.ok(dadosConversa);
    }

    @Transactional
    @GetMapping
    public ResponseEntity listarConversas(Authentication authentication) {
        var usuario = (Usuario) authentication.getPrincipal();
        var conversas = chatService.listarConversas(usuario);
        return ResponseEntity.ok(conversas);
    }

    @GetMapping("/{idConversa}/messages")
    @Transactional
    public ResponseEntity<Page<DadosListagemMensagem>> listarMensagens(
            @PathVariable UUID idConversa,
            Authentication authentication,
            @PageableDefault(size = 50, sort = {"dataEnvio"}) Pageable pageable) {
        var usuario = (Usuario) authentication.getPrincipal();
        var mensagens = chatService.listarMensagens(idConversa, usuario, pageable);
        return ResponseEntity.ok(mensagens);
    }
}
