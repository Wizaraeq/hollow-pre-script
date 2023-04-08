--邪炎帝王テスタロス
function c101201023.initial_effect(c)
	--Tribute Summon by Tributing 1 monster the opponent controls and 1 Tribute Summoned monster you control
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101201023,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c101201023.sumcon)
	e1:SetOperation(c101201023.sumop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e2)
	--Banish 1 random card from the opponent's hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101201023,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCondition(c101201023.rmcon)
	e3:SetTarget(c101201023.rmtg)
	e3:SetOperation(c101201023.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c101201023.valcheck)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)
end
function c101201023.cfilter(c,relzone,tp)
	local rzone=c:IsControler(tp) and (1<<c:GetSequence()) or (1<<(16+c:GetSequence()))
	if c:GetSequence()>=5 then
		rzone=rzone|(c:IsControler(tp) and (1<<(16+11-c:GetSequence())) or (1<<(11-c:GetSequence())))
	end
	return c:IsReleasable() and (c:IsSummonType(SUMMON_TYPE_ADVANCE) or c:IsControler(1-tp))
end
function c101201023.rescon(sg,e,tp,soul_ex_g,zone)
	return (#soul_ex_g==0 or sg&soul_ex_g==soul_ex_g) and Duel.GetMZoneCount(tp,sg,tp,LOCATION_REASON_TOFIELD,zone)>0 and sg:FilterCount(Card.IsControler,nil,tp)==1
end
function c101201023.adjust_zone_value(exeff,c,zone)
	if not exeff then return zone end
	local val=0
	local ret=exeff:GetValue()
	if type(ret)=="function" then
		ret={ret(exeff,c)}
		if #ret>1 then
			val=(ret[2]>>16)&0x7f
		end
	end
	return val
end
function c101201023.sumcon(e,c,minc,zone,relzone,exeff)
	if c==nil then return true end
	if minc>2 or c:IsLevelBelow(6) then return false end
	zone=c101201023.adjust_zone_value(exeff,c,zone)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c101201023.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,relzone,tp)
	local soul_ex_g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,LOCATION_MZONE,nil,EFFECT_EXTRA_RELEASE)
	return #mg>=2 and mg:CheckSubGroup(c101201023.rescon,2,2,e,tp,soul_ex_g,zone)
end
function c101201023.sumop(e,tp,eg,ep,ev,re,r,rp,c,minc,zone,relzone,exeff)
	zone=c101201023.adjust_zone_value(exeff,c,zone)
	local mg=Duel.GetMatchingGroup(c101201023.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,relzone,tp)
	local soul_ex_g=Duel.GetMatchingGroup(Card.IsHasEffect,tp,LOCATION_MZONE,LOCATION_MZONE,nil,EFFECT_EXTRA_RELEASE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=mg:SelectSubGroup(tp,c101201023.rescon,false,2,2,e,tp,soul_ex_g,zone)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	g:DeleteGroup()
end
function c101201023.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c101201023.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_HAND,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c101201023.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
	if #g==0 then return end
	local rg=g:RandomSelect(tp,1)
	if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)>0 and Duel.Damage(1-tp,1000,REASON_EFFECT)>0
		and e:GetLabel()==1
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(101201023,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
		if rc and Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)>0 and rc:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_DARK) and rc:IsLevelAbove(1) then
			Duel.BreakEffect()
			Duel.Damage(1-tp,rc:GetLevel()*200,REASON_EFFECT)
		end
	end
end
function c101201023.valfilter(c)
	return c:IsLevelAbove(8) and c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c101201023.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c101201023.valfilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end