package com.ug.Ukraine_students.controller;

import com.ug.Ukraine_students.domain.UkrainaUczniowie;
import com.ug.Ukraine_students.service.UkrainaUczniowieService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class UkrainaUczniowieController {

    @Autowired
    UkrainaUczniowieService ukrainaUczniowieService;

    @GetMapping("/uczniowie")
    public List<UkrainaUczniowie> getStudents(){
        return ukrainaUczniowieService.getAllStudents();
    }

    @GetMapping("/uczniowie/{id}")
    public UkrainaUczniowie getStudent(@PathVariable("id") Long id) {
        return ukrainaUczniowieService.getStudentById(id);
    }

    @GetMapping("/powiat/{id}")
    public List<UkrainaUczniowie> getStudentsByPowiat(@PathVariable("id") int id) {
        return ukrainaUczniowieService.getAllFromPowiat(id);
    }

    @GetMapping("/uczniowie/params")
    public List<UkrainaUczniowie> getStudentsByParams(
            @RequestParam(required = false) Integer wojewodztwo,
            @RequestParam(required = false) Integer powiat,
            @RequestParam(required = false) Integer publicznosc,
            @RequestParam(required = false) Integer podmiot) {
        return ukrainaUczniowieService.getAllByParams(wojewodztwo, powiat, publicznosc, podmiot);
    }

}
