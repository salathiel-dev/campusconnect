package br.edu.ufr.campusconnect.campusconnectapi.domain.chat;

import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.Produto;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Table(name = "conversas")
@Entity(name = "Conversa")
@Getter
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class Conversa {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "produto_id")
    private Produto produto;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "comprador_id")
    private Usuario comprador;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "vendedor_id")
    private Usuario vendedor;

    @Column(name = "data_criacao")
    private LocalDateTime dataCriacao;

    public Conversa(Produto produto, Usuario comprador, Usuario vendedor) {
        this.produto = produto;
        this.comprador = comprador;
        this.vendedor = vendedor;
    }

    @PrePersist
    protected void onCreate() {
        this.dataCriacao = LocalDateTime.now();
    }
}
