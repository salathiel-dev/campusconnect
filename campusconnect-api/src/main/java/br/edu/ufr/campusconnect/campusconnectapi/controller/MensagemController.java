package br.edu.ufr.campusconnect.campusconnectapi.controller;

import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.ChatService;
import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosEnvioMensagem;
import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosListagemMensagem;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;

@Controller
public class MensagemController {

    @Autowired
    private ChatService chatService;

    @Autowired
    private SimpMessagingTemplate messagingTemplate;

    @MessageMapping("/chat.sendMessage")
    @Transactional
    public void sendMessage(@Payload DadosEnvioMensagem dados, Authentication authentication) {
        var remetente = (Usuario) authentication.getPrincipal();
        var mensagemSalva = chatService.enviarMensagem(dados, remetente);

        messagingTemplate.convertAndSend(
                "/topic/chats/" + mensagemSalva.getConversa().getId(),
                new DadosListagemMensagem(mensagemSalva)
        );
    }
}
