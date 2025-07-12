package br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto;

import java.math.BigDecimal;

public record DadosAtualizacaoProduto(
        String titulo,
        String descricao,
        BigDecimal preco,
        String categoria
) {
}
