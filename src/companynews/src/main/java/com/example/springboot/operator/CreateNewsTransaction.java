package com.example.springboot.operator;

import org.prevayler.TransactionWithQuery;

import java.io.Serializable;
import java.util.Date;

import com.example.springboot.entity.News;
import com.example.springboot.entity.Root;

public class CreateNewsTransaction implements TransactionWithQuery<Root, News>, Serializable {

  private static final long serialVersionUID = 1l;

  private String id;

  public CreateNewsTransaction() {
  }

  public CreateNewsTransaction(String id) {
    this.id = id;
  }

  public News executeAndQuery(Root prevalentSystem, Date executionTime) throws Exception {
    News entity = new News();
    entity.setID(id);
    prevalentSystem.getAllNews().put(entity.getID(), entity);
    return entity;
  }

  public String getID() {
    return id;
  }

  public void setID(String id) {
    this.id = id;
  }
}
