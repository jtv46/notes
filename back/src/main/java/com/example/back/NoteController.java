package com.example.back;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class NoteController {

    @Autowired
    private NoteRepository noteRepository;

    @GetMapping("/notes")
    public List<Note> getNotes() {
        return noteRepository.findAll();
    }

    @PostMapping("/notes")
    public Note createNote(@RequestBody Note note) {
        return noteRepository.save(note);
    }

    @DeleteMapping("/{id}")
    public void deleteNote(@PathVariable Integer id) {
        if (!noteRepository.existsById(id)) {
            throw new RuntimeException("Note not found");
        }
        noteRepository.deleteById(id);
    }

    @PutMapping("/{id}")
    public Note updateNote(@PathVariable Integer id, @RequestBody Note updated) {
        Note note = noteRepository.findById(id).orElseThrow();
        note.setNombre(updated.getNombre());
        note.setContenido(updated.getContenido());
        return noteRepository.save(note);
    }
}