class SearchResponseEntity {
	String msg;
	int code;
	List<SearchResponseData> data;

	SearchResponseEntity({this.msg, this.code, this.data});

	SearchResponseEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		if (json['data'] != null) {
			data = new List<SearchResponseData>();(json['data'] as List).forEach((v) { data.add(new SearchResponseData.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] =  this.data.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class SearchResponseData {
	String dBID;
	List<Null> moviePlayUrls;
	int playCount;
	String releaseDate;
	dynamic listType;
	String movieTitle;
	String name;
	double score;
	String type;
	String cover;
	int year;
	dynamic introduction;
	String updateTime;
	int iD;
	String tags;
	int indexNO;

	SearchResponseData({this.dBID, this.moviePlayUrls, this.playCount, this.releaseDate, this.listType, this.movieTitle, this.name, this.score, this.type, this.cover, this.year, this.introduction, this.updateTime, this.iD, this.tags, this.indexNO});

	SearchResponseData.fromJson(Map<String, dynamic> json) {
		dBID = json['DBID'];
		if (json['MoviePlayUrls'] != null) {
			moviePlayUrls = new List<Null>();
		}
		playCount = json['PlayCount'];
		releaseDate = json['ReleaseDate'];
		listType = json['listType'];
		movieTitle = json['MovieTitle'];
		name = json['Name'];
		score = json['Score'];
		type = json['Type'];
		cover = json['Cover'];
		year = json['Year'];
		introduction = json['Introduction'];
		updateTime = json['UpdateTime'];
		iD = json['ID'];
		tags = json['Tags'];
		indexNO = json['IndexNO'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['DBID'] = this.dBID;
		if (this.moviePlayUrls != null) {
      data['MoviePlayUrls'] =  [];
    }
		data['PlayCount'] = this.playCount;
		data['ReleaseDate'] = this.releaseDate;
		data['listType'] = this.listType;
		data['MovieTitle'] = this.movieTitle;
		data['Name'] = this.name;
		data['Score'] = this.score;
		data['Type'] = this.type;
		data['Cover'] = this.cover;
		data['Year'] = this.year;
		data['Introduction'] = this.introduction;
		data['UpdateTime'] = this.updateTime;
		data['ID'] = this.iD;
		data['Tags'] = this.tags;
		data['IndexNO'] = this.indexNO;
		return data;
	}
}
