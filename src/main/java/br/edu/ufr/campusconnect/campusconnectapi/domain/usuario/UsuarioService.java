package br.edu.ufr.campusconnect.campusconnectapi.domain.usuario;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.dto.DadosCadastroUsuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public Usuario registrar(DadosCadastroUsuario dados) {
        // Futuramente, podemos adicionar validações aqui (ex: e-mail já existe)

        var senhaHash = passwordEncoder.encode(dados.senha());
        var usuario = new Usuario(dados, senhaHash);

        return usuarioRepository.save(usuario);
    }
}
