package br.edu.ufr.campusconnect.campusconnectapi.domain.profile.dto;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import java.util.List;

public record DadosPerfilUsuario(
        String nomeCompleto,
        String email,
        List<DadosProdutoUsuario> meusProdutos
) {
    public DadosPerfilUsuario(Usuario usuario, List<DadosProdutoUsuario> produtos) {
        this(usuario.getNomeCompleto(), usuario.getEmail(), produtos);
    }
}
