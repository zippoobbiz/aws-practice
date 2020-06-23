package com.momenton.companynews.operator;

import org.prevayler.TransactionWithQuery;

import java.util.Date;

import com.momenton.companynews.entity.News;
import com.momenton.companynews.entity.Root;

public class DeleteNewsTransaction implements TransactionWithQuery<Root, News> {

  /**
   * java.io.Serializable with a non changing serialVersionUID
   * will automatically handle backwards compatibility
   * if you add new non transient fields the the class.
   */
  private static final long serialVersionUID = 1l;

  private String id;

  public DeleteNewsTransaction() {
  }

  public DeleteNewsTransaction(String id) {
    this.id = id;
  }

  public News executeAndQuery(Root prevalentSystem, Date executionTime) throws Exception {
    return prevalentSystem.getAllNews().remove(id);
  }

  public String getID() {
    return id;
  }

  public void setIdentity(String id) {
    this.id = id;
  }
}
