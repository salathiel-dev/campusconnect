package br.edu.ufr.campusconnect.campusconnectapi.domain.usuario;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.dto.DadosCadastroUsuario;
import jakarta.persistence.*;
import lombok.*;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.List;
import java.util.UUID;

@Table(name = "usuarios")
@Entity(name = "Usuario")
@Getter
@Setter
@NoArgsConstructor
@EqualsAndHashCode(of = "id")
public class Usuario implements UserDetails{

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

    public Usuario(DadosCadastroUsuario dados, String senhaHash) {
        this.nomeCompleto = dados.nomeCompleto();
        this.email = dados.email();
        this.senhaHash = senhaHash;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // Retorna as permissões do usuário. Aqui, retornamos uma autoridade padrão.
        return List.of(new SimpleGrantedAuthority("ROLE_USER"));
    }

    @Override
    public String getPassword() {
        // Retorna a senha do usuário (hash)
        return this.senhaHash;
    }

    @Override
    public String getUsername() {
        // Retorna o e-mail como identificador do usuário
        return this.email;
    }

    @Override
    public boolean isAccountNonExpired() {
        // Conta não expira
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        // Conta não é bloqueada
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        // Credenciais não expiram
        return true;
    }

    @PrePersist
    protected void onCreate() {
        this.dataCriacao = LocalDateTime.now();
        this.dataAtualizacao = LocalDateTime.now();
        this.ativo = true; // Alterei a inatividade para fazer um teste
        this.avaliacaoMedia = BigDecimal.ZERO;
    }

    @PreUpdate
    protected void onUpdate() {
        this.dataAtualizacao = LocalDateTime.now();
    }
}
