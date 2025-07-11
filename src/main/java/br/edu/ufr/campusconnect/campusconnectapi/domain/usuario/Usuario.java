package br.edu.ufr.campusconnect.campusconnectapi.domain.usuario;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Table(name = "usuarios")
@Entity(name = "Usuario")
@Getter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Usuario {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "nome_completo")
    private String nomeCompleto;

    private String email;

    @Column(name = "senha_hash")
    private String senhaHash;

    private String telefone;

    @Column(name = "foto_perfil_url")
    private String fotoPerfilUrl;

    @Column(name = "curso_departamento")
    private String cursoDepartamento;

    @Column(name = "avaliacao_media")
    private BigDecimal avaliacaoMedia;

    private boolean ativo;

    @Column(name = "data_criacao")
    private LocalDateTime dataCriacao;

    @Column(name = "data_atualizacao")
    private LocalDateTime dataAtualizacao;

    @PrePersist
    protected void onCreate() {
        this.dataCriacao = LocalDateTime.now();
        this.dataAtualizacao = LocalDateTime.now();
        this.ativo = false; // Conta começa inativa até verificação de e-mail
        this.avaliacaoMedia = BigDecimal.ZERO;
    }

    @PreUpdate
    protected void onUpdate() {
        this.dataAtualizacao = LocalDateTime.now();
    }
}