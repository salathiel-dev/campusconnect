package br.edu.ufr.campusconnect.campusconnectapi.domain.produto;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;
import java.util.List;

public interface ProdutoRepository extends JpaRepository<Produto, UUID> {
    Page<Produto> findAllByStatus(StatusProduto status, Pageable paginacao);

    List<Produto> findByVendedorId(UUID vendedorId);
}
