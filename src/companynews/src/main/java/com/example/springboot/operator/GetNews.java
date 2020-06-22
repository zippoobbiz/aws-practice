package com.example.springboot.operator;

import org.prevayler.Query;

import java.util.Date;

import com.example.springboot.entity.News;
import com.example.springboot.entity.Root;

public class GetNews implements Query<Root, News> {

  private static final long serialVersionUID = 3799438221680331803L;
  private String id;

  public GetNews(String id) {
    this.id = id;
  }

  public News query(Root prevalentSystem, Date executionTime) throws Exception {
    return prevalentSystem.getAllNews().get(id);
  }
}
