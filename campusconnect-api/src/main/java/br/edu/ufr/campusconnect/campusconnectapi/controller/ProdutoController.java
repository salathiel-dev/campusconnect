package br.edu.ufr.campusconnect.campusconnectapi.controller;

import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.Produto;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.ProdutoRepository;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.StatusProduto;
import br.edu.ufr.campusconnect.campusconnectapi.domain.produto.dto.DadosAtualizacaoProduto;
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
import br.edu.ufr.campusconnect.campusconnectapi.infra.storage.ImageUploadService;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.RequestParam;

import java.io.IOException;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/products")
public class ProdutoController {

    @Autowired
    private ProdutoRepository repository;

    @Autowired
    private ImageUploadService imageUploadService;

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
        var page = repository.findAllByStatus(StatusProduto.ATIVO, paginacao).map(DadosListagemProduto::new);
        return ResponseEntity.ok(page);
    }

    @GetMapping("/{id}")
    public ResponseEntity detalhar(@PathVariable UUID id) {
        var produto = repository.getOne(id);
        return ResponseEntity.ok(new DadosDetalhamentoProduto(produto));
    }

    @PutMapping("/{id}")
    @Transactional
    public ResponseEntity atualizar(@PathVariable UUID id, @RequestBody DadosAtualizacaoProduto dados, Authentication authentication) {
        var produto = repository.getReferenceById(id);

        var usuarioLogado = (Usuario) authentication.getPrincipal();
        if (!produto.getVendedor().getId().equals(usuarioLogado.getId())) {
            return ResponseEntity.status(403).body("Acesso negado: você não é o vendedor deste produto.");
        }

        produto.atualizarInformacoes(dados);

        return ResponseEntity.ok(new DadosDetalhamentoProduto(produto));
    }

    @DeleteMapping("/{id}")
    @Transactional
    public ResponseEntity excluir(@PathVariable UUID id, Authentication authentication) {
        var produto = repository.getReferenceById(id);

        var usuarioLogado = (Usuario) authentication.getPrincipal();
        if (!produto.getVendedor().getId().equals(usuarioLogado.getId())) {
            return ResponseEntity.status(403).body("Acesso negado: você não é o vendedor deste produto.");
        }

        produto.excluir();

        return ResponseEntity.noContent().build();
    }

    @PostMapping("/{id}/upload-image")
    @Transactional
    public ResponseEntity uploadImage(@PathVariable UUID id, @RequestParam("file") MultipartFile file, Authentication authentication) throws IOException {
        var produto = repository.findById(id).orElseThrow(() -> new RuntimeException("Produto não encontrado"));

        var usuarioLogado = (Usuario) authentication.getPrincipal();
        if (!produto.getVendedor().getId().equals(usuarioLogado.getId())) {
            return ResponseEntity.status(403).body("Acesso negado.");
        }

        String imageUrl = imageUploadService.uploadImage(file);
        produto.setImageUrl(imageUrl);
        repository.save(produto);

        return ResponseEntity.ok().body(Map.of("imageUrl", imageUrl));
    }
}

