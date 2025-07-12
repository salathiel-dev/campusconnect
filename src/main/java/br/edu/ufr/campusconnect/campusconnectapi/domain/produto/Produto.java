package br.edu.ufr.campusconnect.campusconnectapi.domain.produto;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto.DadosCadastroProduto;
import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Table(name = "produtos")
@Entity(name = "Produto")
@Getter
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class Produto {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    private String titulo;

    private String descricao;

    private BigDecimal preco;

    private String categoria;

    @Enumerated(EnumType.STRING)
    private StatusProduto status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vendedor_id")
    private Usuario vendedor;

    @Column(name = "data_criacao")
    private LocalDateTime dataCriacao;

    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;


    public Produto(DadosCadastroProduto dados, Usuario vendedor) {
        this.titulo = dados.titulo();
        this.descricao = dados.descricao();
        this.preco = dados.preco();
        this.categoria = dados.categoria();
        this.vendedor = vendedor;
    }

    @PrePersist
    protected void onCreate() {
        this.dataCriacao = LocalDateTime.now();
        this.dataAtualizacao = LocalDateTime.now();
        this.status = StatusProduto.ATIVO;
    }

    @PreUpdate
    protected void onUpdate() {
        this.dataAtualizacao = LocalDateTime.now();
    }

}
