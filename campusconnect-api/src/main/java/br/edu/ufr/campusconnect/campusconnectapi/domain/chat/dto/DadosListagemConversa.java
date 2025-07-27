package br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto;

import java.time.LocalDateTime;
import java.util.UUID;

public record DadosListagemConversa(
        UUID idConversa,
        String tituloProduto,
        String nomeOutroParticipante,
        String ultimaMensagem,
        LocalDateTime dataUltimaMensagem
) {
}
