package com.ug.Ukraine_students.service;

import com.ug.Ukraine_students.domain.UkrainaUczniowie;

import java.util.List;

public interface IUkrainaUczniowieService {
    UkrainaUczniowie getStudentById(long id);
    List<UkrainaUczniowie> getAllStudents();
    List<UkrainaUczniowie> getAllFromPowiat(int idPowiat);
    List<UkrainaUczniowie> getAllByParams(Integer idTerytWojewodztwo, Integer idTerytPowiat, Integer idPublicznosc, Integer idTypPodmiotu);
}
