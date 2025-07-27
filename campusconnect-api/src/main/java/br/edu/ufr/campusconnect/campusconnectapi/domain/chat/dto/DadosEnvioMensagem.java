package br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto;

import java.util.UUID;

public record DadosEnvioMensagem(
        UUID conversaId,
        String conteudo
) {
}
