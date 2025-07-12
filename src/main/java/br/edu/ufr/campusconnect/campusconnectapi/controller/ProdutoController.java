package br.edu.ufr.campusconnect.campusconnectapi.controller;

import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.Produto;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.ProdutoRepository;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto.DadosCadastroProduto;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto.DadosDetalhamentoProduto;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto.DadosListagemProduto;
import br.edu.ufr.campusconnect.campusconnectapi.domain.usuario.Usuario;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.UUID;

@RestController
@RequestMapping("/products")
public class ProdutoController {

    @Autowired
    private ProdutoRepository repository;

    @PostMapping
    @Transactional
    public ResponseEntity cadastrar(@RequestBody DadosCadastroProduto dados, Authentication authentication, UriComponentsBuilder uriBuilder) {
        var vendedor = (Usuario) authentication.getPrincipal();
        var produto = new Produto(dados, vendedor);
        repository.save(produto);

        var uri = uriBuilder.path("/products/{id}").buildAndExpand(produto.getId()).toUri();

        return ResponseEntity.created(uri).body(new DadosDetalhamentoProduto(produto));
    }

    @GetMapping
    public ResponseEntity<Page<DadosListagemProduto>> listar(@PageableDefault(size = 10, sort = {"dataCriacao"}) Pageable paginacao) {
        var page = repository.findAll(paginacao).map(DadosListagemProduto::new);
        return ResponseEntity.ok(page);
    }

    @GetMapping("/{id}")
    public ResponseEntity detalhar(@PathVariable UUID id) {
        var produto = repository.getOne(id);
        return ResponseEntity.ok(new DadosDetalhamentoProduto(produto));
    }
}

