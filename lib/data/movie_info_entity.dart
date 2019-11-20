class MovieInfoEntity {
	String msg;
	int code;
	MovieInfoData data;

	MovieInfoEntity({this.msg, this.code, this.data});

	MovieInfoEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		code = json['code'];
		data = json['data'] != null ? new MovieInfoData.fromJson(json['data']) : null;
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		data['code'] = this.code;
		if (this.data != null) {
      data['data'] = this.data.toJson();
    }
		return data;
	}
}

class MovieInfoData {
	String dBID;
	List<MovieInfoDataMovieplayurl> moviePlayUrls;
	int playCount;
	String releaseDate;
	dynamic listType;
	String movieTitle;
	String name;
	double score;
	String type;
	String cover;
	int year;
	String introduction;
	String updateTime;
	int iD;
	String tags;
	int indexNO;

	MovieInfoData({this.dBID, this.moviePlayUrls, this.playCount, this.releaseDate, this.listType, this.movieTitle, this.name, this.score, this.type, this.cover, this.year, this.introduction, this.updateTime, this.iD, this.tags, this.indexNO});

	MovieInfoData.fromJson(Map<String, dynamic> json) {
		dBID = json['DBID'];
		if (json['MoviePlayUrls'] != null) {
			moviePlayUrls = new List<MovieInfoDataMovieplayurl>();(json['MoviePlayUrls'] as List).forEach((v) { moviePlayUrls.add(new MovieInfoDataMovieplayurl.fromJson(v)); });
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
      data['MoviePlayUrls'] =  this.moviePlayUrls.map((v) => v.toJson()).toList();
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

class MovieInfoDataMovieplayurl {
	String playUrl;
	int index;
	int sourceTypeID;
	int iD;
	String sourceTypeName;
	String name;

	MovieInfoDataMovieplayurl({this.playUrl, this.index, this.sourceTypeID, this.iD, this.sourceTypeName, this.name});

	MovieInfoDataMovieplayurl.fromJson(Map<String, dynamic> json) {
		playUrl = json['PlayUrl'];
		index = json['Index'];
		sourceTypeID = json['SourceTypeID'];
		iD = json['ID'];
		sourceTypeName = json['SourceTypeName'];
		name = json['Name'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['PlayUrl'] = this.playUrl;
		data['Index'] = this.index;
		data['SourceTypeID'] = this.sourceTypeID;
		data['ID'] = this.iD;
		data['SourceTypeName'] = this.sourceTypeName;
		data['Name'] = this.name;
		return data;
	}
}
