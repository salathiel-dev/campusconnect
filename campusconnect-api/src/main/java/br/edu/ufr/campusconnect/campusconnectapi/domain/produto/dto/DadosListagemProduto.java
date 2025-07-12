package br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto;

import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.Produto;
import java.math.BigDecimal;
import java.util.UUID;

public record DadosListagemProduto(UUID id, String titulo, BigDecimal preco, String nomeVendedor) {
    public DadosListagemProduto(Produto produto) {
        this(produto.getId(), produto.getTitulo(), produto.getPreco(), produto.getVendedor().getNomeCompleto());
    }
}
