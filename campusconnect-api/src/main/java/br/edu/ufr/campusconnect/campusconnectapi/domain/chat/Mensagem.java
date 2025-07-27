package br.edu.ufr.campusconnect.campusconnectapi.domain.chat;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import jakarta.persistence.*;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.UUID;

@Table(name = "mensagens")
@Entity(name = "Mensagem")
@Getter
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class Mensagem {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conversa_id")
    private Conversa conversa;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "remetente_id")
    private Usuario remetente;

    @Lob
    private String conteudo;

    @Column(name = "data_envio")
    private LocalDateTime dataEnvio;

    public Mensagem(Conversa conversa, Usuario remetente, String conteudo) {
        this.conversa = conversa;
        this.remetente = remetente;
        this.conteudo = conteudo;
    }

    @PrePersist
    protected void onCreate() {
        this.dataEnvio = LocalDateTime.now();
    }
}
