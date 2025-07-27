package br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto;

import java.util.UUID;

public record DadosRetornoConversa(
        UUID idConversa,
        UUID idProduto,
        String nomeOutroParticipante

) {
}
