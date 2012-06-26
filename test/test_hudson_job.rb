require 'test/unit'
$LOAD_PATH << File.dirname(__FILE__) + "/../lib"
require 'hudson-remote-api.rb'

class TestHudsonJob < Test::Unit::TestCase
  TEST_SVN_REPO_URL = "http://svn.apache.org/repos/asf/subversion/trunk/doc/user/"
  
  def setup
    Hudson[:url] = "http://localhost:8080"
  end
  
  def test_list
    assert Hudson::Job.list
  end
  
  def test_list_active
      assert Hudson::Job.list_active
  end
  
  def test_create
    new_job_name = 'new_test_job'
    new_job = Hudson::Job.create(new_job_name)
    assert new_job
    assert_equal(new_job.name, new_job_name)
    assert new_job.delete
  end
  
  def test_get
    job = Hudson::Job.get('test_job')
    assert job
    assert_equal 'test_job', job.name, "failed to get job name"
  end
  
  def test_desc_update
    job = Hudson::Job.new('test_job')
    assert job.description = "test"
    assert job.description != nil, "Job description should not be nil"
  end
  
  def test_scm_url
    job = Hudson::Job.new('test_svn_job')
    job.build
    assert job.repository_url = TEST_SVN_REPO_URL
    
    job = Hudson::Job.new('test_svn_job')
    assert_equal TEST_SVN_REPO_URL, job.repository_url
  end
  
  def test_new
    job = Hudson::Job.new('test_job')
    assert job
    assert_equal(job.name, 'test_job')
    
    new_job = Hudson::Job.new('test_job2')
    assert new_job
    assert_equal('test_job2', new_job.name)
    assert new_job.delete
  end
  
  def test_copy
    job = Hudson::Job.get('test_job')
    new_job = job.copy
    assert new_job
    assert_equal(new_job.name, 'copy_of_test_job')
    assert new_job.delete
  end

  def test_url
    job = Hudson::Job.get("test_job")
    assert_equal(job.url, "http://localhost:8080/job/#{job.name}/")
  end
  
  def test_job_with_spaces
    job = Hudson::Job.create('test job with spaces')
    assert job
    assert job.name
    assert job.delete
  end
  
  def test_builds_list
    job = Hudson::Job.get("test_job")
    assert job.builds_list.kind_of?(Array)
  end
end
