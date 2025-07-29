package br.edu.ufr.campusconnect.campusconnectapi.domain.profile.dto;

import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.Produto;
import java.math.BigDecimal;
import java.util.UUID;

public record DadosProdutoUsuario(
        UUID id,
        String titulo,
        BigDecimal preco,
        String status
) {
    public DadosProdutoUsuario(Produto produto) {
        this(produto.getId(), produto.getTitulo(), produto.getPreco(), produto.getStatus().name());
    }
}
