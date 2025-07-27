package br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto;

import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.Mensagem;

import java.time.LocalDateTime;
import java.util.UUID;

public record DadosListagemMensagem(
        UUID idMensagem,
        UUID idRemetente,
        String conteudo,
        LocalDateTime dataEnvio
) {
    public DadosListagemMensagem(Mensagem mensagem) {
        this(mensagem.getId(), mensagem.getRemetente().getId(), mensagem.getConteudo(), mensagem.getDataEnvio());
    }
}
