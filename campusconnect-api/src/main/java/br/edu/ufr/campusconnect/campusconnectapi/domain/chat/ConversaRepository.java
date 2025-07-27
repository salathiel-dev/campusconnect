package br.edu.ufr.campusconnect.campusconnectapi.domain.chat;

import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface ConversaRepository extends JpaRepository<Conversa, UUID> {
    Conversa findByProdutoIdAndCompradorId(UUID produtoId, UUID compradorId);
    List<Conversa> findByCompradorIdOrVendedorId(UUID compradorId, UUID vendedorId);
}
