package br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto;

import java.math.BigDecimal;

public record DadosCadastroProduto(
        String titulo,
        String descricao,
        BigDecimal preco,
        String categoria) {
}
