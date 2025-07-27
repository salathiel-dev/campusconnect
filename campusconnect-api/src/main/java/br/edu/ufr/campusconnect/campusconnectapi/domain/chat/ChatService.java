package br.edu.ufr.campusconnect.campusconnectapi.domain.chat;

import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosIniciarConversa;
import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosRetornoConversa;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.ProdutoRepository;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosListagemConversa;
import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosListagemMensagem;
import br.edu.ufr.campusconnect.campusconnectapi.domain.chat.dto.DadosEnvioMensagem;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class ChatService {

    @Autowired
    private ConversaRepository conversaRepository;

    @Autowired
    private ProdutoRepository produtoRepository;

    @Autowired
    private MensagemRepository mensagemRepository;

    public DadosRetornoConversa iniciarOuRetornarConversa(DadosIniciarConversa dados, Usuario comprador) {
        var conversaExistente = conversaRepository.findByProdutoIdAndCompradorId(dados.produtoId(), comprador.getId());

        if (conversaExistente != null) {
            return new DadosRetornoConversa(
                    conversaExistente.getId(),
                    conversaExistente.getProduto().getId(),
                    conversaExistente.getVendedor().getNomeCompleto()
            );
        }

        var produto = produtoRepository.findById(dados.produtoId())
                .orElseThrow(() -> new RuntimeException("Produto não encontrado"));

        var novaConversa = new Conversa();
        novaConversa = new Conversa(produto, comprador, produto.getVendedor());
        conversaRepository.save(novaConversa);

        return new DadosRetornoConversa(
                novaConversa.getId(),
                novaConversa.getProduto().getId(),
                novaConversa.getVendedor().getNomeCompleto()
        );
    }

    public List<DadosListagemConversa> listarConversas(Usuario usuario) {
        List<Conversa> conversas = conversaRepository.findByCompradorIdOrVendedorId(usuario.getId(), usuario.getId());

        return conversas.stream().map(conversa -> {
            Optional<Mensagem> ultimaMensagemOpt = mensagemRepository.findTopByConversaIdOrderByDataEnvioDesc(conversa.getId());
            Usuario outroParticipante = conversa.getComprador().getId().equals(usuario.getId()) ? conversa.getVendedor() : conversa.getComprador();

            return new DadosListagemConversa(
                    conversa.getId(),
                    conversa.getProduto().getTitulo(),
                    outroParticipante.getNomeCompleto(),
                    ultimaMensagemOpt.map(Mensagem::getConteudo).orElse("Nenhuma mensagem ainda."),
                    ultimaMensagemOpt.map(Mensagem::getDataEnvio).orElse(conversa.getDataCriacao())
            );
        }).collect(Collectors.toList());
    }

    public Page<DadosListagemMensagem> listarMensagens(UUID conversaId, Usuario usuario, Pageable pageable) {
        var conversa = conversaRepository.findById(conversaId)
                .orElseThrow(() -> new RuntimeException("Conversa não encontrada"));

        if (!conversa.getComprador().getId().equals(usuario.getId()) && !conversa.getVendedor().getId().equals(usuario.getId())) {
            throw new SecurityException("Acesso negado a esta conversa.");
        }

        return mensagemRepository.findByConversaId(conversaId, pageable).map(DadosListagemMensagem::new);
    }

    public Mensagem enviarMensagem(DadosEnvioMensagem dados, Usuario remetente) {
        var conversa = conversaRepository.findById(dados.conversaId())
                .orElseThrow(() -> new RuntimeException("Conversa não encontrada"));

        if (!conversa.getComprador().getId().equals(remetente.getId()) && !conversa.getVendedor().getId().equals(remetente.getId())) {
            throw new SecurityException("Acesso negado: o remetente não pertence a esta conversa.");
        }

        var novaMensagem = new Mensagem(conversa, remetente, dados.conteudo());
        return mensagemRepository.save(novaMensagem);
    }
}
