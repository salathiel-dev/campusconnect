package br.edu.ufr.campusconnect.campusconnectapi.domain.chat;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;
import java.util.UUID;

public interface MensagemRepository extends JpaRepository<Mensagem, UUID> {
    Page<Mensagem> findByConversaId(UUID conversaId, Pageable pageable);
    Optional<Mensagem> findTopByConversaIdOrderByDataEnvioDesc(UUID conversaId);
}
