package com.pocproject.awspocproject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class ApplicationController {

    @Autowired
    private BookRepository bookRepository;

    @GetMapping("/books")
    public List<Book> getAllBooks() {
        return bookRepository.findAll();
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("UP");
    }

    @GetMapping("/")
    public ResponseEntity<String> checkup() {
        return ResponseEntity.ok("working..Good");
    }

    @GetMapping("/frozen")
    public ResponseEntity<String> frozen() {
        return ResponseEntity.ok("frozen.!");
    }

}
