// ORM class for table 't_coupon_action'
// WARNING: This class is AUTO-GENERATED. Modify at your own risk.
//
// Debug information:
// Generated date: Sun May 27 09:59:36 CST 2018
// For connector: org.apache.sqoop.manager.MySQLManager
import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.Writable;
import org.apache.hadoop.mapred.lib.db.DBWritable;
import com.cloudera.sqoop.lib.JdbcWritableBridge;
import com.cloudera.sqoop.lib.DelimiterSet;
import com.cloudera.sqoop.lib.FieldFormatter;
import com.cloudera.sqoop.lib.RecordParser;
import com.cloudera.sqoop.lib.BooleanParser;
import com.cloudera.sqoop.lib.BlobRef;
import com.cloudera.sqoop.lib.ClobRef;
import com.cloudera.sqoop.lib.LargeObjectLoader;
import com.cloudera.sqoop.lib.SqoopRecord;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class t_coupon_action extends SqoopRecord  implements DBWritable, Writable {
  private final int PROTOCOL_VERSION = 3;
  public int getClassFormatVersion() { return PROTOCOL_VERSION; }
  protected ResultSet __cur_result_set;
  private Integer id;
  public Integer get_id() {
    return id;
  }
  public void set_id(Integer id) {
    this.id = id;
  }
  public t_coupon_action with_id(Integer id) {
    this.id = id;
    return this;
  }
  private String code;
  public String get_code() {
    return code;
  }
  public void set_code(String code) {
    this.code = code;
  }
  public t_coupon_action with_code(String code) {
    this.code = code;
    return this;
  }
  private String action_type;
  public String get_action_type() {
    return action_type;
  }
  public void set_action_type(String action_type) {
    this.action_type = action_type;
  }
  public t_coupon_action with_action_type(String action_type) {
    this.action_type = action_type;
    return this;
  }
  private java.sql.Timestamp action_time;
  public java.sql.Timestamp get_action_time() {
    return action_time;
  }
  public void set_action_time(java.sql.Timestamp action_time) {
    this.action_time = action_time;
  }
  public t_coupon_action with_action_time(java.sql.Timestamp action_time) {
    this.action_time = action_time;
    return this;
  }
  private String action_result;
  public String get_action_result() {
    return action_result;
  }
  public void set_action_result(String action_result) {
    this.action_result = action_result;
  }
  public t_coupon_action with_action_result(String action_result) {
    this.action_result = action_result;
    return this;
  }
  private String operated_by;
  public String get_operated_by() {
    return operated_by;
  }
  public void set_operated_by(String operated_by) {
    this.operated_by = operated_by;
  }
  public t_coupon_action with_operated_by(String operated_by) {
    this.operated_by = operated_by;
    return this;
  }
  private String reference_type;
  public String get_reference_type() {
    return reference_type;
  }
  public void set_reference_type(String reference_type) {
    this.reference_type = reference_type;
  }
  public t_coupon_action with_reference_type(String reference_type) {
    this.reference_type = reference_type;
    return this;
  }
  private java.sql.Timestamp last_updated_at;
  public java.sql.Timestamp get_last_updated_at() {
    return last_updated_at;
  }
  public void set_last_updated_at(java.sql.Timestamp last_updated_at) {
    this.last_updated_at = last_updated_at;
  }
  public t_coupon_action with_last_updated_at(java.sql.Timestamp last_updated_at) {
    this.last_updated_at = last_updated_at;
    return this;
  }
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof t_coupon_action)) {
      return false;
    }
    t_coupon_action that = (t_coupon_action) o;
    boolean equal = true;
    equal = equal && (this.id == null ? that.id == null : this.id.equals(that.id));
    equal = equal && (this.code == null ? that.code == null : this.code.equals(that.code));
    equal = equal && (this.action_type == null ? that.action_type == null : this.action_type.equals(that.action_type));
    equal = equal && (this.action_time == null ? that.action_time == null : this.action_time.equals(that.action_time));
    equal = equal && (this.action_result == null ? that.action_result == null : this.action_result.equals(that.action_result));
    equal = equal && (this.operated_by == null ? that.operated_by == null : this.operated_by.equals(that.operated_by));
    equal = equal && (this.reference_type == null ? that.reference_type == null : this.reference_type.equals(that.reference_type));
    equal = equal && (this.last_updated_at == null ? that.last_updated_at == null : this.last_updated_at.equals(that.last_updated_at));
    return equal;
  }
  public boolean equals0(Object o) {
    if (this == o) {
      return true;
    }
    if (!(o instanceof t_coupon_action)) {
      return false;
    }
    t_coupon_action that = (t_coupon_action) o;
    boolean equal = true;
    equal = equal && (this.id == null ? that.id == null : this.id.equals(that.id));
    equal = equal && (this.code == null ? that.code == null : this.code.equals(that.code));
    equal = equal && (this.action_type == null ? that.action_type == null : this.action_type.equals(that.action_type));
    equal = equal && (this.action_time == null ? that.action_time == null : this.action_time.equals(that.action_time));
    equal = equal && (this.action_result == null ? that.action_result == null : this.action_result.equals(that.action_result));
    equal = equal && (this.operated_by == null ? that.operated_by == null : this.operated_by.equals(that.operated_by));
    equal = equal && (this.reference_type == null ? that.reference_type == null : this.reference_type.equals(that.reference_type));
    equal = equal && (this.last_updated_at == null ? that.last_updated_at == null : this.last_updated_at.equals(that.last_updated_at));
    return equal;
  }
  public void readFields(ResultSet __dbResults) throws SQLException {
    this.__cur_result_set = __dbResults;
    this.id = JdbcWritableBridge.readInteger(1, __dbResults);
    this.code = JdbcWritableBridge.readString(2, __dbResults);
    this.action_type = JdbcWritableBridge.readString(3, __dbResults);
    this.action_time = JdbcWritableBridge.readTimestamp(4, __dbResults);
    this.action_result = JdbcWritableBridge.readString(5, __dbResults);
    this.operated_by = JdbcWritableBridge.readString(6, __dbResults);
    this.reference_type = JdbcWritableBridge.readString(7, __dbResults);
    this.last_updated_at = JdbcWritableBridge.readTimestamp(8, __dbResults);
  }
  public void readFields0(ResultSet __dbResults) throws SQLException {
    this.id = JdbcWritableBridge.readInteger(1, __dbResults);
    this.code = JdbcWritableBridge.readString(2, __dbResults);
    this.action_type = JdbcWritableBridge.readString(3, __dbResults);
    this.action_time = JdbcWritableBridge.readTimestamp(4, __dbResults);
    this.action_result = JdbcWritableBridge.readString(5, __dbResults);
    this.operated_by = JdbcWritableBridge.readString(6, __dbResults);
    this.reference_type = JdbcWritableBridge.readString(7, __dbResults);
    this.last_updated_at = JdbcWritableBridge.readTimestamp(8, __dbResults);
  }
  public void loadLargeObjects(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void loadLargeObjects0(LargeObjectLoader __loader)
      throws SQLException, IOException, InterruptedException {
  }
  public void write(PreparedStatement __dbStmt) throws SQLException {
    write(__dbStmt, 0);
  }

  public int write(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeInteger(id, 1 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(code, 2 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(action_type, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(action_time, 4 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeString(action_result, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(operated_by, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(reference_type, 7 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(last_updated_at, 8 + __off, 93, __dbStmt);
    return 8;
  }
  public void write0(PreparedStatement __dbStmt, int __off) throws SQLException {
    JdbcWritableBridge.writeInteger(id, 1 + __off, 4, __dbStmt);
    JdbcWritableBridge.writeString(code, 2 + __off, 1, __dbStmt);
    JdbcWritableBridge.writeString(action_type, 3 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(action_time, 4 + __off, 93, __dbStmt);
    JdbcWritableBridge.writeString(action_result, 5 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(operated_by, 6 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeString(reference_type, 7 + __off, 12, __dbStmt);
    JdbcWritableBridge.writeTimestamp(last_updated_at, 8 + __off, 93, __dbStmt);
  }
  public void readFields(DataInput __dataIn) throws IOException {
this.readFields0(__dataIn);  }
  public void readFields0(DataInput __dataIn) throws IOException {
    if (__dataIn.readBoolean()) { 
        this.id = null;
    } else {
    this.id = Integer.valueOf(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.code = null;
    } else {
    this.code = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.action_type = null;
    } else {
    this.action_type = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.action_time = null;
    } else {
    this.action_time = new Timestamp(__dataIn.readLong());
    this.action_time.setNanos(__dataIn.readInt());
    }
    if (__dataIn.readBoolean()) { 
        this.action_result = null;
    } else {
    this.action_result = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.operated_by = null;
    } else {
    this.operated_by = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.reference_type = null;
    } else {
    this.reference_type = Text.readString(__dataIn);
    }
    if (__dataIn.readBoolean()) { 
        this.last_updated_at = null;
    } else {
    this.last_updated_at = new Timestamp(__dataIn.readLong());
    this.last_updated_at.setNanos(__dataIn.readInt());
    }
  }
  public void write(DataOutput __dataOut) throws IOException {
    if (null == this.id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.id);
    }
    if (null == this.code) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, code);
    }
    if (null == this.action_type) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, action_type);
    }
    if (null == this.action_time) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.action_time.getTime());
    __dataOut.writeInt(this.action_time.getNanos());
    }
    if (null == this.action_result) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, action_result);
    }
    if (null == this.operated_by) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, operated_by);
    }
    if (null == this.reference_type) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, reference_type);
    }
    if (null == this.last_updated_at) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.last_updated_at.getTime());
    __dataOut.writeInt(this.last_updated_at.getNanos());
    }
  }
  public void write0(DataOutput __dataOut) throws IOException {
    if (null == this.id) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeInt(this.id);
    }
    if (null == this.code) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, code);
    }
    if (null == this.action_type) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, action_type);
    }
    if (null == this.action_time) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.action_time.getTime());
    __dataOut.writeInt(this.action_time.getNanos());
    }
    if (null == this.action_result) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, action_result);
    }
    if (null == this.operated_by) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, operated_by);
    }
    if (null == this.reference_type) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    Text.writeString(__dataOut, reference_type);
    }
    if (null == this.last_updated_at) { 
        __dataOut.writeBoolean(true);
    } else {
        __dataOut.writeBoolean(false);
    __dataOut.writeLong(this.last_updated_at.getTime());
    __dataOut.writeInt(this.last_updated_at.getNanos());
    }
  }
  private static final DelimiterSet __outputDelimiters = new DelimiterSet((char) 124, (char) 10, (char) 0, (char) 0, false);
  public String toString() {
    return toString(__outputDelimiters, true);
  }
  public String toString(DelimiterSet delimiters) {
    return toString(delimiters, true);
  }
  public String toString(boolean useRecordDelim) {
    return toString(__outputDelimiters, useRecordDelim);
  }
  public String toString(DelimiterSet delimiters, boolean useRecordDelim) {
    StringBuilder __sb = new StringBuilder();
    char fieldDelim = delimiters.getFieldsTerminatedBy();
    __sb.append(FieldFormatter.escapeAndEnclose(id==null?"\\N":"" + id, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(code==null?"\\N":code, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(action_type==null?"\\N":action_type, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(action_time==null?"\\N":"" + action_time, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(action_result==null?"\\N":action_result, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(operated_by==null?"\\N":operated_by, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(reference_type==null?"\\N":reference_type, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(last_updated_at==null?"\\N":"" + last_updated_at, delimiters));
    if (useRecordDelim) {
      __sb.append(delimiters.getLinesTerminatedBy());
    }
    return __sb.toString();
  }
  public void toString0(DelimiterSet delimiters, StringBuilder __sb, char fieldDelim) {
    __sb.append(FieldFormatter.escapeAndEnclose(id==null?"\\N":"" + id, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(code==null?"\\N":code, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(action_type==null?"\\N":action_type, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(action_time==null?"\\N":"" + action_time, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(action_result==null?"\\N":action_result, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(operated_by==null?"\\N":operated_by, delimiters));
    __sb.append(fieldDelim);
    // special case for strings hive, droppingdelimiters \n,\r,\01 from strings
    __sb.append(FieldFormatter.hiveStringDropDelims(reference_type==null?"\\N":reference_type, delimiters));
    __sb.append(fieldDelim);
    __sb.append(FieldFormatter.escapeAndEnclose(last_updated_at==null?"\\N":"" + last_updated_at, delimiters));
  }
  private static final DelimiterSet __inputDelimiters = new DelimiterSet((char) 124, (char) 10, (char) 0, (char) 0, false);
  private RecordParser __parser;
  public void parse(Text __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharSequence __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(byte [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(char [] __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(ByteBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  public void parse(CharBuffer __record) throws RecordParser.ParseError {
    if (null == this.__parser) {
      this.__parser = new RecordParser(__inputDelimiters);
    }
    List<String> __fields = this.__parser.parseRecord(__record);
    __loadFromFields(__fields);
  }

  private void __loadFromFields(List<String> fields) {
    Iterator<String> __it = fields.listIterator();
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.id = null; } else {
      this.id = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.code = null; } else {
      this.code = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.action_type = null; } else {
      this.action_type = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.action_time = null; } else {
      this.action_time = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.action_result = null; } else {
      this.action_result = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.operated_by = null; } else {
      this.operated_by = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.reference_type = null; } else {
      this.reference_type = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.last_updated_at = null; } else {
      this.last_updated_at = java.sql.Timestamp.valueOf(__cur_str);
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  private void __loadFromFields0(Iterator<String> __it) {
    String __cur_str = null;
    try {
    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.id = null; } else {
      this.id = Integer.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.code = null; } else {
      this.code = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.action_type = null; } else {
      this.action_type = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.action_time = null; } else {
      this.action_time = java.sql.Timestamp.valueOf(__cur_str);
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.action_result = null; } else {
      this.action_result = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.operated_by = null; } else {
      this.operated_by = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null")) { this.reference_type = null; } else {
      this.reference_type = __cur_str;
    }

    __cur_str = __it.next();
    if (__cur_str.equals("null") || __cur_str.length() == 0) { this.last_updated_at = null; } else {
      this.last_updated_at = java.sql.Timestamp.valueOf(__cur_str);
    }

    } catch (RuntimeException e) {    throw new RuntimeException("Can't parse input data: '" + __cur_str + "'", e);    }  }

  public Object clone() throws CloneNotSupportedException {
    t_coupon_action o = (t_coupon_action) super.clone();
    o.action_time = (o.action_time != null) ? (java.sql.Timestamp) o.action_time.clone() : null;
    o.last_updated_at = (o.last_updated_at != null) ? (java.sql.Timestamp) o.last_updated_at.clone() : null;
    return o;
  }

  public void clone0(t_coupon_action o) throws CloneNotSupportedException {
    o.action_time = (o.action_time != null) ? (java.sql.Timestamp) o.action_time.clone() : null;
    o.last_updated_at = (o.last_updated_at != null) ? (java.sql.Timestamp) o.last_updated_at.clone() : null;
  }

  public Map<String, Object> getFieldMap() {
    Map<String, Object> __sqoop$field_map = new TreeMap<String, Object>();
    __sqoop$field_map.put("id", this.id);
    __sqoop$field_map.put("code", this.code);
    __sqoop$field_map.put("action_type", this.action_type);
    __sqoop$field_map.put("action_time", this.action_time);
    __sqoop$field_map.put("action_result", this.action_result);
    __sqoop$field_map.put("operated_by", this.operated_by);
    __sqoop$field_map.put("reference_type", this.reference_type);
    __sqoop$field_map.put("last_updated_at", this.last_updated_at);
    return __sqoop$field_map;
  }

  public void getFieldMap0(Map<String, Object> __sqoop$field_map) {
    __sqoop$field_map.put("id", this.id);
    __sqoop$field_map.put("code", this.code);
    __sqoop$field_map.put("action_type", this.action_type);
    __sqoop$field_map.put("action_time", this.action_time);
    __sqoop$field_map.put("action_result", this.action_result);
    __sqoop$field_map.put("operated_by", this.operated_by);
    __sqoop$field_map.put("reference_type", this.reference_type);
    __sqoop$field_map.put("last_updated_at", this.last_updated_at);
  }

  public void setField(String __fieldName, Object __fieldVal) {
    if ("id".equals(__fieldName)) {
      this.id = (Integer) __fieldVal;
    }
    else    if ("code".equals(__fieldName)) {
      this.code = (String) __fieldVal;
    }
    else    if ("action_type".equals(__fieldName)) {
      this.action_type = (String) __fieldVal;
    }
    else    if ("action_time".equals(__fieldName)) {
      this.action_time = (java.sql.Timestamp) __fieldVal;
    }
    else    if ("action_result".equals(__fieldName)) {
      this.action_result = (String) __fieldVal;
    }
    else    if ("operated_by".equals(__fieldName)) {
      this.operated_by = (String) __fieldVal;
    }
    else    if ("reference_type".equals(__fieldName)) {
      this.reference_type = (String) __fieldVal;
    }
    else    if ("last_updated_at".equals(__fieldName)) {
      this.last_updated_at = (java.sql.Timestamp) __fieldVal;
    }
    else {
      throw new RuntimeException("No such field: " + __fieldName);
    }
  }
  public boolean setField0(String __fieldName, Object __fieldVal) {
    if ("id".equals(__fieldName)) {
      this.id = (Integer) __fieldVal;
      return true;
    }
    else    if ("code".equals(__fieldName)) {
      this.code = (String) __fieldVal;
      return true;
    }
    else    if ("action_type".equals(__fieldName)) {
      this.action_type = (String) __fieldVal;
      return true;
    }
    else    if ("action_time".equals(__fieldName)) {
      this.action_time = (java.sql.Timestamp) __fieldVal;
      return true;
    }
    else    if ("action_result".equals(__fieldName)) {
      this.action_result = (String) __fieldVal;
      return true;
    }
    else    if ("operated_by".equals(__fieldName)) {
      this.operated_by = (String) __fieldVal;
      return true;
    }
    else    if ("reference_type".equals(__fieldName)) {
      this.reference_type = (String) __fieldVal;
      return true;
    }
    else    if ("last_updated_at".equals(__fieldName)) {
      this.last_updated_at = (java.sql.Timestamp) __fieldVal;
      return true;
    }
    else {
      return false;    }
  }
}
