package br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto;

import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.Produto;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.StatusProduto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

public record DadosDetalhamentoProduto(
        UUID id,
        String titulo,
        String descricao,
        BigDecimal preco,
        String categoria,
        StatusProduto status,
        String nomeVendedor,
        UUID idVendedor,
        LocalDateTime dataCriacao
) {
    public DadosDetalhamentoProduto(Produto produto) {
        this(
                produto.getId(),
                produto.getTitulo(),
                produto.getDescricao(),
                produto.getPreco(),
                produto.getCategoria(),
                produto.getStatus(),
                produto.getVendedor().getNomeCompleto(),
                produto.getVendedor().getId(),
                produto.getDataCriacao()
        );
    }
}
