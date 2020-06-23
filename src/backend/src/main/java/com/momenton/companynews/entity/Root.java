package com.momenton.companynews.entity;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class Root implements Serializable {

  /**
   * java.io.Serializable with a non changing serialVersionUID
   * will automatically handle backwards compatibility
   * if you add new non transient fields the the class.
   */
  private static final long serialVersionUID = 1l;

  private Map<String, News> allNews = new HashMap<String, News>();


  public Map<String, News> getAllNews() {
    return allNews;
  }

  public void setAllNews(Map<String, News> allNews) {
    this.allNews = allNews;
  }
}
