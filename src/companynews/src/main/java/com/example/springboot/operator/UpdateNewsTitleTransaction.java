package com.example.springboot.operator;

import org.prevayler.Transaction;

import java.io.Serializable;
import java.util.Date;

import com.example.springboot.entity.Root;

public class UpdateNewsTitleTransaction implements Serializable, Transaction<Root> {

  /**
   * java.io.Serializable with a non changing serialVersionUID
   * will automatically handle backwards compatibility
   * if you add new non transient fields the the class.
   */
  private static final long serialVersionUID = 1l;

  private String id;
  private String title;

  public UpdateNewsTitleTransaction() {
  }

  public UpdateNewsTitleTransaction(String id, String title) {
    this.id = id;
    this.title = title;
  }

  public void executeOn(Root prevalentSystem, Date executionTime) {
    prevalentSystem.getAllNews().get(id).setTitle(title);
  }

  public String getID() {
    return id;
  }

  public void setID(String id) {
    this.id = id;
  }

  public String getTitle() {
    return title;
  }

  public void setTitle(String title) {
    this.title = title;
  }
}
