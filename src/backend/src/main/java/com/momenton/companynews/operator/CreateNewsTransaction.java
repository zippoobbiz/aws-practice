package com.momenton.companynews.operator;

import com.momenton.companynews.entity.News;
import com.momenton.companynews.entity.Root;
import java.util.Date;
import org.prevayler.TransactionWithQuery;

public class CreateNewsTransaction implements TransactionWithQuery<Root, News> {

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
  