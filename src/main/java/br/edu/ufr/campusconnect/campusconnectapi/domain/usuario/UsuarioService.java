package br.edu.ufr.campusconnect.campusconnectapi.domain.usuario;

import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.dto.DadosCadastroUsuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

@Service
public class UsuarioService implements UserDetailsService {

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

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        // O Spring Security chama este método. O "username" aqui é o nosso e-mail.
        return usuarioRepository.findByEmail(username);
    }
}
